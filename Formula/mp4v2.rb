class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://code.google.com/archive/p/mp4v2/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mp4v2/mp4v2-2.0.0.tar.bz2"
  sha256 "0319b9a60b667cf10ee0ec7505eb7bdc0a2e21ca7a93db96ec5bd758e3428338"

  bottle do
    cellar :any
    rebuild 2
    sha256 "eca897528879a7ae32b0a780c7d952459aea0aac0a52388f2e2985333346d3fd" => :high_sierra
    sha256 "2acf82636548d994dc5f130a35aa2caca5eedd02493cb5564e17f021d9687a67" => :sierra
    sha256 "addfef2648f0edbfacf427d31d49d0995ecf55072c1390f43ef5b7fc69cd76fb" => :el_capitan
  end

  conflicts_with "bento4",
    :because => "both install `mp4extract` and `mp4info` binaries"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mp4art --version")
  end
end
