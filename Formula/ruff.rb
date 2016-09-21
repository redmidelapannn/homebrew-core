class Ruff < Formula
  desc "IoT platform with JavaScript as application language"
  homepage "https://ruff.io"
  url "http://sdk.ruff.io/ruff-sdk-mac-1.5.0.zip"
  sha256 "764e8d84ce7d8b31d41867b038538564f1b8ecd2a9eae8e8e3a79040a351fd4b"

  bottle do
    cellar :any
    sha256 "0c9aa5333fd3614cf71904b5751cee9e680b591f047e74b6cd8093a5a7d7462b" => :sierra
    sha256 "0c9aa5333fd3614cf71904b5751cee9e680b591f047e74b6cd8093a5a7d7462b" => :el_capitan
    sha256 "0c9aa5333fd3614cf71904b5751cee9e680b591f047e74b6cd8093a5a7d7462b" => :yosemite
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    (testpath/"ruff-test.js").write <<-EOS.undent
      console.log("hello, Ruff")
    EOS
    system "#{bin}/ruff", testpath/"ruff-test.js"
  end
end
