class Sdees < Formula
  desc "Serverless Decentralized Editing of Encrypted Stuff"
  homepage "https://github.com/schollz/sdees"
  url "https://github.com/schollz/sdees/releases/download/1.2.1/sdees_osx_amd64.zip"
  version "1.2.1"
  sha256 "8ba3a210518837a0af50d5290a982ae38e2b38b5858112800fdabbca885d6020"

  bottle do
    cellar :any_skip_relocation
    sha256 "20989139509d2832a3287b5f48a323d10172adc947838fe7bc394f11b527148c" => :el_capitan
    sha256 "c6e33523db2847924cab13f9f940761892ae60c22f833dd3c1260d082ddcc468" => :yosemite
    sha256 "c6e33523db2847924cab13f9f940761892ae60c22f833dd3c1260d082ddcc468" => :mavericks
  end

  def install
    bin.install "sdees"
  end

  test do
    system "sdees"
  end
end
