class Xcenv < Formula
  desc "Xcode version manager"
  homepage "https://github.com/xcenv/xcenv#readme"
  url "https://github.com/xcenv/xcenv/archive/v1.0.0.tar.gz"
  sha256 "257fbb6c13aa434142a5b74686114eb432b6f0f005a6127aa53b1c2628870d39"
  head "https://github.com/xcenv/xcenv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44ef844200a744d69e48f8f5574e54e24560799d9ecf6cb04d9d7f20ab5ac7e7" => :el_capitan
    sha256 "03a642b7af921d65c673de503131290cc932f3c153258bc47d398b938d7ea002" => :yosemite
    sha256 "0224383ad76f82d9a6b8878c045740c5ac0663ea159ff794c6760d948e46a1ea" => :mavericks
  end

  def install
    prefix.install ["bin", "libexec"]
  end

  def caveats; <<-EOS.undent
    Xcenv stores data under ~/.xcenv by default. If you absolutely need to
    store everything under Homebrew's prefix, include this in your profile:
      export XCENV_ROOT=#{var}/xcenv
    To enable shims and autocompletion, run this and follow the instructions:
      xcenv init
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
