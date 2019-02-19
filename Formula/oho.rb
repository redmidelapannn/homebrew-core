class Oho < Formula
  desc "Takes your colorful terminal output and converts it to HTML for sharing"
  homepage "https://github.com/masukomi/oho"
  bottle do
    sha256 "ff365accda746a11b4119c557b2a0d3c40c1cb6b8cd63db59cbf71adae3627a7" => :mojave
    sha256 "e65685951f02106dd5e690b8dbbba51411173dbc8e3654888974f4ac6220a1c0" => :high_sierra
    sha256 "556fb8ed81d1e7044938fb46b3d3da161a2b29ed551a93c23223441d642c9fe7" => :sierra
  end

  current_version="v1.3.2"
  url "https://github.com/masukomi/oho/releases/download/#{current_version}/oho_#{current_version}-source.tgz"
  sha256 "8ccd7d425d198adef47b2171c18d8ebd463e831ad23c7be654583118cac08751"

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"

  def install
    system "crystal", "build", "--release", "src/oho.cr"
    bin.install "oho"
  end

  test do
    out = pipe_output(bin/"oho", "[35mno[34mfascism[00m")
    style_regexp = %r{<span style="color: fuchsia; ">no<\/span><span style="color: #3333FF; ">fascism<\/span>}
    assert_match(style_regexp, out)
  end
end
