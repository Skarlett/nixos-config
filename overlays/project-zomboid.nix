{self, system, ...}:
{
  pzstart = self.packages.${system}.pzstart;
  pzupdate = self.packages.${system}.pzupdate;
}
