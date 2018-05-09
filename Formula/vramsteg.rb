class Vramsteg < Formula
  desc "Add progress bars to command-line applications"
  homepage "https://gothenburgbitfactory.org/projects/vramsteg.html"
  url "https://gothenburgbitfactory.org/download/vramsteg-1.1.0.tar.gz"
  sha256 "9cc82eb195e4673d9ee6151373746bd22513033e96411ffc1d250920801f7037"
  head "https://github.com/GothenburgBitFactory/vramsteg.git", :branch => "1.1.1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "27430ea6263ec4538e7d7d13280a2957894c0f6e478cc9a1c466d77517d9e879" => :high_sierra
    sha256 "9a35de0ec2a81078961109db7d969178f546af6ed09138a35c20a5e39d588241" => :sierra
    sha256 "ec67d1ffb8e726f18a79f876e6c7df562cc828de269993882726cc30e1d8b30a" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Check to see if vramsteg can obtain the current time as epoch
    assert_match /^\d+$/, shell_output("#{bin}/vramsteg --now")
  end
end
