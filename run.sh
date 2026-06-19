#!/usr/bin/env bash
set -euo pipefail

# Fill this in
# T3_UNLEARNING_DIR="your-prefix/T3-Unlearning" 

OPEN_UNLEARNING_DIR="${T3_UNLEARNING_DIR}/open-unlearning"
cd ${OPEN_UNLEARNING_DIR}

export PYTHONUNBUFFERED=1
export LOGLEVEL=INFO

NNODES=1
NMACHINES=1
export MASTER_ADDR="127.0.0.1"
export MASTER_PORT="$(python - <<'PY'
import socket
s = socket.socket()
s.bind(("", 0))
print(s.getsockname()[1])
s.close()
PY
)"

model="Llama-3.1-8B-Instruct"
trainer="T3"
experiment="unlearn/tofu/default"

FORGET_PCT="05"
forget_split="forget${FORGET_PCT}"
holdout_split="holdout${FORGET_PCT}"
retain_split="retain$(( 100 - 10#$FORGET_PCT ))"

seed=1
num_epochs=100
warmup_epochs=25
lr=1e-3
weight_decay=1e-3
hidden_size=20
num_hidden_layers=1
extraction_layer=-1
activation_str="id"
guidance_scale=1
base_temp=2.5
bias="false"
pooling="mean"
per_device_train_batch_size=32
gradient_accumulation_steps=1

task_name="tofu_${model}_${forget_split}_T3_verify"
model_path=open-unlearning/tofu_${model}_full
echo ${task_name}: Unlearning ${model_path} using ${trainer}

# Unlearn
python src/train.py \
  --config-name=unlearn.yaml \
  experiment=${experiment} \
  eval=tofu \
  trainer=${trainer} \
  task_name=${task_name} \
  model=${model} \
  forget_split=${forget_split} \
  retain_split=${retain_split} \
  model.model_args.pretrained_model_name_or_path=${model_path} \
  retain_logs_path=saves/eval/tofu_${model}_${retain_split}/TOFU_EVAL.json \
  trainer.args.per_device_train_batch_size=${per_device_train_batch_size} \
  trainer.args.gradient_accumulation_steps=${gradient_accumulation_steps} \
  trainer.args.gradient_checkpointing=false \
  trainer.args.ddp_find_unused_parameters=true \
  trainer.args.seed=${seed} \
  trainer.args.num_train_epochs=${num_epochs} \
  trainer.args.learning_rate=${lr} \
  trainer.args.weight_decay=${weight_decay} \
  trainer.args.warmup_epochs=${warmup_epochs} \
  trainer.method_args.extraction_layer=${extraction_layer} \
  trainer.method_args.pooling=${pooling} \
  trainer.method_args.guidance_scale=${guidance_scale} \
  trainer.method_args.base_temp=${base_temp} \
  trainer.method_args.guidance_cfg.hidden_size=${hidden_size} \
  trainer.method_args.guidance_cfg.num_hidden_layers=${num_hidden_layers} \
  trainer.method_args.guidance_cfg.activation_str=${activation_str} \
  trainer.method_args.guidance_cfg.bias=${bias} \
  trainer.args.eval_strategy="no" \
  trainer.args.eval_on_start=false \
  trainer.args.do_eval=false

echo "======================================="
echo "FINISHED UNLEARNING"
echo "RUNNING EVAL..."
echo "======================================="

# Eval
python src/eval.py \
  experiment=eval/tofu/default \
  forget_split=${forget_split} \
  holdout_split=${holdout_split} \
  model=${model} \
  task_name=${task_name} \
  eval=tofu \
  model.model_args.pretrained_model_name_or_path=saves/unlearn/${task_name} \
  paths.output_dir=saves/unlearn/${task_name}/evals \
  retain_logs_path=saves/eval/tofu_${model}_${retain_split}/TOFU_EVAL.json \
  seed=${seed} \
  model.model_args.torch_dtype=float16 \
  model.model_args.attn_implementation=sdpa 
