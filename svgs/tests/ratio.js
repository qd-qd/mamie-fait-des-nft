const ratioBy = (ratio, by) =>
  new Array(by)
    .fill(1)
    .map(
      (_, i) =>
        ((i % (ratio + 2)) % ((i % (ratio + 1)) + 1)) % ((i % ratio) + 1)
    )
    .reduce((a, b) => {
      a[b] = (a[b] | 0) + 1;
      return a;
    }, {});
