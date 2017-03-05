class Jargon < Formula
  desc "Helps you import localizations from a Google Spreadsheet"
  homepage "https://github.com/dmiotti/jargon"
  url "https://raw.githubusercontent.com/dmiotti/jargon/master/releases/download/0.0.1/jargon.tar.gz"
  sha256 "900be186a0421d8e5dc47b413c7d56918c4663050a01b408afd3a536e565c436"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b651724ba19a606b083c520fbc8932765c6bcf4b3d9ab7b0dbcc3b2e7b569e0" => :sierra
    sha256 "9b651724ba19a606b083c520fbc8932765c6bcf4b3d9ab7b0dbcc3b2e7b569e0" => :el_capitan
    sha256 "9b651724ba19a606b083c520fbc8932765c6bcf4b3d9ab7b0dbcc3b2e7b569e0" => :yosemite
  end

  def install
    bin.install "jargon"
  end

  test do
  end
end
