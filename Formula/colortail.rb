class Colortail < Formula
  desc "Like tail(1), but with various colors for specified output"
  homepage "https://github.com/joakim666/colortail"
  url "https://github.com/joakim666/colortail.git",
    :revision => "f44fce0dbfd6bd38cba03400db26a99b489505b5"
  version "0.3.4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7e8bbc0a2eab36ea27f4f9e4cc16483a497c4578256dddab92e79af926bcf571" => :sierra
    sha256 "245af2902ebd7d436891b94e497f62a39c80c7bd42923a1fcd36407251c8874d" => :el_capitan
    sha256 "2673172313b8aec58809c180ab9b349bb1c1f6b05ec9dce5fb35db5c59552eb3" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  # Upstream PR to fix the build on ML
  patch do
    url "https://github.com/joakim666/colortail/commit/36dd0437bb364fd1493934bdb618cc102a29d0a5.diff"
    sha256 "2bb9963f6fc586c8faff3b51a48896cf09c68c4229c39c6ae978a59cb58d0fd7"
  end

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello\nWorld!\n"
    assert_match(/World!/, shell_output("#{bin}/colortail -n 1 test.txt"))
  end
end
