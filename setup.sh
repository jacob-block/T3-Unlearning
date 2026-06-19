#!/usr/bin/env bash
set -euo pipefail

# Fill this in
# T3_UNLEARNING_DIR="your-prefix/T3-Unlearning" 

OPEN_UNLEARNING_DIR="${T3_UNLEARNING_DIR}/open-unlearning"

# Clone repo
git clone https://github.com/locuslab/open-unlearning.git "${OPEN_UNLEARNING_DIR}/"
cd ${OPEN_UNLEARNING_DIR}
git checkout 4ad738aaf60f6a4385f6e2506d01da99e76c31f3

# Install dependencies
conda create -n unlearning -y python=3.11
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate unlearning
conda install -y pip
pip install ".[lm-eval]"
pip install --no-cache-dir --no-build-isolation flash-attn==2.6.3

# Setup eval data
python setup_data.py --eval

# Apply changes
rsync -av \
  --include configs/ \
  --include configs/trainer/ \
  --include configs/trainer/T3.yaml \
  --include src/ \
  --include src/evals/ \
  --include src/evals/metrics/ \
  --include src/evals/metrics/t3.py \
  --include src/model/ \
  --include src/model/t3.py \
  --include src/trainer/ \
  --include src/trainer/unlearn/ \
  --include src/trainer/unlearn/t3.py \
  --exclude src/trainer/__init__.py \
  --exclude src/model/__init__.py \
  --exclude src/evals/metrics/__init__.py \
  --exclude '*' \
  ${T3_UNLEARNING_DIR}/ ./

patch -p1 < ${T3_UNLEARNING_DIR}/changes.patch
