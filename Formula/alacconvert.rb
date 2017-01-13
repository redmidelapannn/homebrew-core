class Alacconvert < Formula
  desc "ALAC (Apple Lossless Audio Codec) encoder/decoder"
  homepage "https://macosforge.github.io/alac/"
  url "https://github.com/macosforge/alac.git",
    :revision => "c38887c5c5e64a4b31108733bd79ca9b2496d987"
  version "0.0.1"
  head "https://github.com/macosforge/alac.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4419ff988b81373a139645a7c3bedb7b86eea3f9ec75425d05f7d6d9847cc701" => :sierra
    sha256 "a327c6544047ad09bddf61cc4d82f3cb109639e7815704d9ed0c753fbc3f74f8" => :el_capitan
    sha256 "f6cdd1c87e7169d288a6380848ea123d06e7972e5b8170c53d4c148e697419f2" => :yosemite
  end

  def install
    cd "convert-utility" do
      system "make"
      bin.install "alacconvert"
    end
  end

  test do
    sample = test_fixtures("test.wav")
    assert_equal "Input file: #{sample}\nOutput file: result.caf\n", shell_output("#{bin}/alacconvert #{sample} result.caf", 0)
  end
end
