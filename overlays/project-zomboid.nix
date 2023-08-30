{self, system, ...}:
f: p: {
  pzstart = self.packages.${system}.pzstart;
  pzupdate = self.packages.${system}.pzupdate;
}
