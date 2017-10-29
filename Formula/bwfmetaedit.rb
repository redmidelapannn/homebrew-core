class Bwfmetaedit < Formula
  desc "Tool that supports embedding, validating, and exporting of metadata in Broadcast WAVE Format (BWF) files"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.2/BWFMetaEdit_CLI_1.3.2_GNU_FromSource.tar.bz2"
  version "1.3.2"
  sha256 "2109d625cc834e38bf05641d550fcb0fe8c095f3fdc0fa69283d26410e4a9f74"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3e9697de34e0bc27fab60464a5b4ae9d69701eec304ce24676e05f33356e3415" => :high_sierra
    sha256 "b193ea95afb056795c6956de5a3640d9060b7fe003857731ca7b616aeb9d5e5a" => :el_capitan
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure",  "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/bwfmetaedit --out-tech", test_fixtures("test.wav"))
  end
end
