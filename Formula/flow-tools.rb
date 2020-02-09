class FlowTools < Formula
  desc "Collect, send, process, and generate NetFlow data reports"
  homepage "https://code.google.com/archive/p/flow-tools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/flow-tools/flow-tools-0.68.5.1.tar.bz2"
  sha256 "80bbd3791b59198f0d20184761d96ba500386b0a71ea613c214a50aa017a1f67"

  bottle do
    rebuild 1
    sha256 "b340f779ac91d57beb62fad917755281e489adff8b5b8a3f1e440cf9e6338c1d" => :catalina
    sha256 "321e8d4fc1ef2ddb233ca9ea21cb118bcdc88fd742d8b279793326be10dd3013" => :mojave
    sha256 "0149bf78376625858412d1d2e18add416ded74d5e7a77a5037dd2930b9d9dfd4" => :high_sierra
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Generate test flow data with 1000 flows
    data = shell_output("#{bin}/flow-gen")
    # Test that the test flows work with some flow- programs
    pipe_output("#{bin}/flow-cat", data, 0)
    pipe_output("#{bin}/flow-print", data, 0)
    pipe_output("#{bin}/flow-stat", data, 0)
  end
end
