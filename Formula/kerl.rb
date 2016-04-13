class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/yrashk/kerl"
  url "https://github.com/yrashk/kerl/archive/0.9.tar.gz"
  sha256 "48d8c2abec3a9567114426defbb9254e87db654ef027dd7a1c0bd58c94fb2399"
  head "https://github.com/yrashk/kerl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ba47800bfdda81c84f83e8e57bd184e1176978671017b4554fc42c914ecd118" => :el_capitan
    sha256 "e2273fbe2d98cc4424116b79bf9719b9555edba45d1185c7e37de7a2b9645f14" => :yosemite
    sha256 "a1c01ae7b023ac0558faf3fbfa1e91d92d7021f35dc99ecc490573a1171e66a9" => :mavericks
  end

  def install
    bin.install "kerl"
    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system "#{bin}/kerl", "list", "releases"
  end
end
