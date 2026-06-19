T3-Unlearning
=================================================

Official page for the paper:
**"Temper-Then-Tilt: Principled Unlearning for Generative Models through Tempering and Classifier Guidance" (ICML 2026)**

Paper: [https://arxiv.org/abs/2602.10217](https://arxiv.org/abs/2602.10217)

---

### Codebase

This code is a minimal diff-only release to the [open-unlearning](https://github.com/locuslab/open-unlearning)
repository which was used as the backbone for all experiments. It is intended to be overlaid onto a pinned checkout of
`open-unlearning`; it is not a standalone copy of that project.

Pinned upstream commit:

```text
4ad738aaf60f6a4385f6e2506d01da99e76c31f3
```

---

### Setup

Run `setup.sh` uncommenting and changing the `T3_UNLEARNING_DIR` as needed.

Note that the specific unlearning parameters for T3-Unlearning and the other methods may need to be tuned for each specific user environment or setup.

---

### Local Run

Run `run.sh` uncommenting and changing the `T3_UNLEARNING_DIR` as needed.

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
