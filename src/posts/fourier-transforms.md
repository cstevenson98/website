---
layout: layouts/post.njk
title: A short note on Fourier transforms
description: Sample math-heavy post to verify KaTeX rendering.
date: 2026-07-26
tags:
  - posts
---

This post exists to check that inline and display math render correctly via KaTeX.

The Fourier transform of an integrable function $f$ is

$$
\hat{f}(\xi) = \int_{-\infty}^{\infty} f(x)\, e^{-2\pi i x \xi}\,\mathrm{d}x.
$$

Under mild conditions the inverse recovers $f$:

$$
f(x) = \int_{-\infty}^{\infty} \hat{f}(\xi)\, e^{2\pi i x \xi}\,\mathrm{d}\xi.
$$

Plancherel's theorem says the transform is an isometry on $L^2(\mathbb{R})$:

$$
\|f\|_{L^2} = \|\hat{f}\|_{L^2}.
$$

Inline check: the Gaussian $e^{-\pi x^2}$ is an eigenfunction of the Fourier transform with eigenvalue $1$.
