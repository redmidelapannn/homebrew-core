class Swiftformat < Formula
    desc "Formatting tool for Swift source code"
  bottle do
    cellar :any_skip_relocation
    sha256 "16e90699fa0241fc35660d9272eae5b7039001524fb46710a374e5a0d10edcd9" => :sierra
    sha256 "16e90699fa0241fc35660d9272eae5b7039001524fb46710a374e5a0d10edcd9" => :el_capitan
    sha256 "16e90699fa0241fc35660d9272eae5b7039001524fb46710a374e5a0d10edcd9" => :yosemite
  end

    homepage "https://github.com/nicklockwood/SwiftFormat"
    url "https://github.com/nicklockwood/SwiftFormat/archive/0.17.tar.gz"
    sha256 "68cfc0f783ca331a1fda1c8b5c5a670b6c42be72a44a34b519d61d308b2fe8ea"

    def install
        bin.install "CommandLineTool/swiftformat"
    end

    test do
        system "#{bin}/swiftformat"
    end
end
