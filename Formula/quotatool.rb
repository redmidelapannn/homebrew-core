class Quotatool < Formula
  desc "Edit disk quotas from the command-line"
  homepage "https://quotatool.ekenberg.se/"
  url "https://quotatool.ekenberg.se/quotatool-1.6.2.tar.gz"
  sha256 "e53adc480d54ae873d160dc0e88d78095f95d9131e528749fd982245513ea090"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c525261cc54620818d861842eda0c51c0e0ca7706ce936cf68a05ab98081e489" => :sierra
    sha256 "bdd0fe97c58ab2872644fc897de358215950f6dad2924524d5d8238434fc1d65" => :el_capitan
    sha256 "9a7d4e268db9457037059d068a6c5a4ac02cdf6db2a1a29809073d57bcc2116f" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    sbin.mkpath
    man8.mkpath
    system "make", "install"
  end

  test do
    system "#{sbin}/quotatool", "-V"
  end
end
