class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.7.5.tar.gz"
  sha256 "9d99ae18666f0e63fe7aef9ad4eed18440d4f395329ef616758d087b9b1f758b"

  bottle do
    rebuild 1
    sha256 "bc5eff6f9e7aae6906aac12b76399bb3128346f4906b6c3b1e0a9ada5bd861b1" => :mojave
    sha256 "99bbb32e476d7e036507ee4b16d67f82665cb3d3182b6329393eb461d88e02a0" => :high_sierra
    sha256 "a5c0e98d96ac5553e861a94f8bc6eeb3130b26afd712fcd8c8a45fb3db733a0f" => :sierra
    sha256 "202612ef0dce8be47360b0213a818aea5f66bcdd344ef325d1e429c6869bf3d8" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
