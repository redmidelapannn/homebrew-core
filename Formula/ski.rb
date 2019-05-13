class Ski < Formula
  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  url "http://www.catb.org/~esr/ski/ski-6.12.tar.gz"
  sha256 "2f34f64868deb0cc773528c68d9829119fac359c44a704695214d87773df5a33"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "841c4c389b462709815586d32a5557883102b9e6fc8dd5b6b6d49d60a030b528" => :mojave
  end

  head do
    url "https://gitlab.com/esr/ski.git"
    depends_on "xmlto" => :build
  end

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "make"
    end
    bin.install "ski"
    man6.install "ski.6"
  end

  test do
    assert_match "Bye!", pipe_output("#{bin}/ski", "")
  end
end
