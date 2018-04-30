class Insteadman < Formula
  desc "INSTEAD manager"
  homepage "https://jhekasoft.github.io/insteadman"
  url "https://github.com/jhekasoft/insteadman3/archive/v3.0.8.tar.gz"
  sha256 "d60a46dbfbfcc99021fc2b8942aaa6af0e9d27501a11e401e1de3e70cc88993a"

  bottle do
    cellar :any
    sha256 "2f0ccce7150b25d4c98edbe825bf60924941b5cacb0ed685f21ce3d4b594216f" => :high_sierra
    sha256 "22ddc077eef4248874c4741b70dd78aa3147a774f3155ab3899259f283913282" => :sierra
    sha256 "8c65d7d82da9e6fa51238240916af283e49db50e54459c6245643c4cd6c94c10" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "go" => :build
  depends_on "gtk+3"
  depends_on "instead"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/insteadman version 2>&1")
  end
end
