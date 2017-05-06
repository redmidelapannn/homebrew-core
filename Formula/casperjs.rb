class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/casperjs/casperjs/archive/1.1.4-1.tar.gz"
  version "1.1.4-1"
  sha256 "c95dd17ac58872e9b74dcfd0d55ce22a5545abdae237cc2b9b945fe14c9a2d31"
  head "https://github.com/casperjs/casperjs.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5a1bad40f6f4758451267e68e28f370ab0382f8dbe63a279799b6f565147686e" => :sierra
    sha256 "bf77c9d934d77666036af7bfc05eb3ca7c7073213ea3424bd4826f19240dea1c" => :el_capitan
    sha256 "bf77c9d934d77666036af7bfc05eb3ca7c7073213ea3424bd4826f19240dea1c" => :yosemite
  end

  depends_on "phantomjs"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/casperjs"
  end

  test do
    (testpath/"fetch.js").write <<-EOS.undent
      var casper = require("casper").create();
      casper.start("https://duckduckgo.com/about", function() {
        this.download("https://duckduckgo.com/assets/dax-alt.svg", "dax-alt.svg");
      });
      casper.run();
    EOS

    system bin/"casperjs", testpath/"fetch.js"
    assert File.exist?("dax-alt.svg")
  end
end
