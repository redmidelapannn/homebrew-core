class Odt2txt < Formula
  desc "Convert OpenDocument files to plain text"
  homepage "https://github.com/dstosberg/odt2txt/"
  url "https://github.com/dstosberg/odt2txt/archive/v0.5.tar.gz"
  sha256 "23a889109ca9087a719c638758f14cc3b867a5dcf30a6c90bf6a0985073556dd"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "1fa1baa04abf9ce269601b620daaf604b0d3ad0cb95ed458aab6149fbaa26a8b" => :mojave
    sha256 "8cf1cdaf56076778a4431fd8b5876dafd51565540fe53a3fa7ac453c30f111d1" => :high_sierra
    sha256 "5e7b2472c711aacebba9e59e0a90b255f03f48412ee263e9e2cff045554eb77d" => :sierra
  end

  resource "sample" do
    url "https://github.com/Turbo87/odt2txt/raw/samples/samples/sample-1.odt"
    sha256 "78a5b17613376e50a66501ec92260d03d9d8106a9d98128f1efb5c07c8bfa0b2"
  end

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    resources.each do |r|
      r.fetch
      system "#{bin}/odt2txt", r.cached_download
    end
  end
end
