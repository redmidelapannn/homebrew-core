class Pazi < Formula
  desc "Replacement for autojump, z, fasd, j"
  homepage "https://github.com/euank/pazi"
  url "https://github.com/euank/pazi/archive/v0.4.1.tar.gz"
  sha256 "f513561451b29fed6d4eb3387524df597b5811cd7744eac77d96e368022b6adc"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e7914ce91615609c7302c9eb48121a7f8d43b068ef8f9c7826140b4148ebc18" => :catalina
    sha256 "f68dba1d15232374a81383d5eb3bb60d6b7a9030e8aef6f93ff7a046ffda1e58" => :mojave
    sha256 "c332fea5974234f944810893d241753ae17b6d0ba1fb216e9a788c9cfdff4a7f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end
end
