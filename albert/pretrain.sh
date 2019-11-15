#!/usr/bin/env bash

export MODEL_DIR=gs://koursaros/tiny
wget https://storage.googleapis.com/tfhub-modules/google/albert_base/2.tar.gz
mkdir ${MODEL_DIR}
tar -xvzf 2.tar.gz --directory=${MODEL_DIR}
# Converting weights to TF 2.0
python converter.py --tf_hub_path=${MODEL_DIR}/ --model_type=albert --version=2 --model=base
# Copy albert_config.json to config.json
cp ${MODEL_DIR}/assets/albert_config.json ${MODEL_DIR}/config.json
# Rename assets to vocab
mv ${MODEL_DIR}/assets/ ${MODEL_DIR}/vocab
# Delete unwanted files
rm -rf ${MODEL_DIR}/saved_model.pb ${MODEL_DIR}/variables/ ${MODEL_DIR}/saved_model.pb ${MODEL_DIR}/tfhub_module.pb

export DATA_DIR=gs://koursaros/data/subset/
export PROCESSED_DATA=gs://koursaros/processed_data
export MODEL_DIR=tiny
python3 create_pretraining_data.py \
--input_file=${DATA_DIR}/*.txt.* \
--output_file=${PROCESSED_DATA}/train.tf_record \
--spm_model_file=${MODEL_DIR}/vocab/30k-clean.model \
--meta_data_file_path=${PROCESSED_DATA}/train_meta_data \
--vocab_file ${MODEL_DIR}/vocab/30k-clean.vocab


export STORAGE_BUCKET=gs://koursaros
export PRETRAINED_MODEL=${STORAGE_BUCKET}/tiny
export PROCESSED_DATA=${STORAGE_BUCKET}/processed_data
export MODEL_DIR=${STORAGE_BUCKET}/tiny

python3 run_pretraining.py \
--albert_config_file=${MODEL_DIR}/config.json \
--do_train \
--input_file=${PROCESSED_DATA}/train.tf_record \
--meta_data_file_path=${PROCESSED_DATA}/train_meta_data \
--output_dir=${PRETRAINED_MODEL} \
--strategy_type=mirror \
--train_batch_size=128 \
--num_train_epochs=3 \
--use_tpu=True \
--tpu_name=jp954
