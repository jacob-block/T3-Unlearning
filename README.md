T3-Unlearning
=================================================

Official page for the paper:
**"Temper-Then-Tilt: Principled Unlearning for Generative Models through Tempering and Classifier Guidance" (ICML 2026)**

Paper: [https://arxiv.org/abs/2602.10217](https://arxiv.org/abs/2602.10217)

---

### Code

T3-Unlearning is implemented in [open-unlearning](https://github.com/locuslab/open-unlearning), added in [#196](https://github.com/locuslab/open-unlearning/pull/196):

- Method page and example sweep: [`community/methods/T3`](https://github.com/locuslab/open-unlearning/tree/main/community/methods/T3)
- Model (frozen base LM + guidance head, guided decoding): [`src/model/t3.py`](https://github.com/locuslab/open-unlearning/blob/main/src/model/t3.py)
- Trainer: [`src/trainer/unlearn/t3.py`](https://github.com/locuslab/open-unlearning/blob/main/src/trainer/unlearn/t3.py)
- Config: [`configs/trainer/T3.yaml`](https://github.com/locuslab/open-unlearning/blob/main/configs/trainer/T3.yaml)
- Metrics: [`src/evals/metrics/t3.py`](https://github.com/locuslab/open-unlearning/blob/main/src/evals/metrics/t3.py)

---

### Quick Start

Install open-unlearning following its [installation instructions](https://github.com/locuslab/open-unlearning#-quickstart), then from the open-unlearning root:

```bash
python setup_data.py --eval
bash community/methods/T3/run.sh
```

Note that the unlearning hyperparameters for T3-Unlearning and the other methods may need to be tuned for each specific user environment or setup.

---

### Citation

```bibtex
@inproceedings{block:2026:T3-Unlearning,
  title={Temper-Then-Tilt: Principled Unlearning for Generative Models through Tempering and Classifier Guidance},
  author={Jacob L. Block and Mehryar Mohri and Aryan Mokhtari and Sanjay Shakkottai},
  booktitle={Forty-third International Conference on Machine Learning},
  year={2026},
}
```

---

### License

This project is licensed under the **Apache 2.0 License** (see `LICENSE` file).
