{self, system, ...}:
final: prev: {
  pzstart = self.packages.${system}.pzstart;
  pzupdate = self.packages.${system}.pzupdate;
}
