class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/casperjs/casperjs/archive/1.1.4-2.tar.gz"
  version "1.1.4-2"
  sha256 "239b9c95c0e4ab534a3939a8769b5a552315b986472dee967850a407e9b60062"
  head "https://github.com/casperjs/casperjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1569410fafea04cb0d78066a4b842448d43b1fb2156ae99a789d6556b89ba815" => :high_sierra
    sha256 "885f4f9d0b7e6ceabcde8c5542d14766212e7d189ae426c4bbe6ecd99eb25148" => :sierra
    sha256 "8f0ae4b24ce77c1fa4b93f480dcaa24b64dd0b0b8ac10ea695b91c18d1908568" => :el_capitan
    sha256 "8f0ae4b24ce77c1fa4b93f480dcaa24b64dd0b0b8ac10ea695b91c18d1908568" => :yosemite
  end

  depends_on "phantomjs"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/casperjs"
  end

  test do
    (testpath/"fetch.js").write <<~EOS
      var casper = require("casper").create();
      casper.start("https://duckduckgo.com/about", function() {
        this.download("https://duckduckgo.com/assets/dax-alt.svg", "dax-alt.svg");
      });
      casper.run();
    EOS

    system bin/"casperjs", testpath/"fetch.js"
    assert_predicate testpath/"dax-alt.svg", :exist?
  end
end
