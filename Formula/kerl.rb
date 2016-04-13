class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/yrashk/kerl"
  url "https://github.com/yrashk/kerl/archive/0.9.tar.gz"
  sha256 "48d8c2abec3a9567114426defbb9254e87db654ef027dd7a1c0bd58c94fb2399"
  head "https://github.com/yrashk/kerl.git"

  def install
    bin.install "kerl"
    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system "#{bin}/kerl", "list", "releases"
  end
end
