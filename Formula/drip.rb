class Drip < Formula
  desc "JVM launching without the hassle of persistent JVMs"
  homepage "https://github.com/flatland/drip"
  url "https://github.com/flatland/drip/archive/0.2.4.tar.gz"
  sha256 "9ed25e29759a077d02ddac61785f33d1f2e015b74f1fd934890aba4a35b3551d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d9de550406e6a8599b3832a2e981c89e998b1c65d55361c3231bbc365a65a8fe" => :mojave
    sha256 "0c71826559a80a83948018bf4c071e7c76f508db352d471301099516c3020088" => :high_sierra
    sha256 "ab182a1f39d191d3096799879b9487b8644721e200a3973e3a489cf61dddcdae" => :sierra
  end

  depends_on :java => "1.8"

  def install
    system "make"
    libexec.install %w[bin src Makefile]
    bin.install_symlink libexec/"bin/drip"
  end

  test do
    ENV["DRIP_HOME"] = testpath
    system "#{bin}/drip", "version"
  end
end
