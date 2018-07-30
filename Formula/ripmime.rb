class Ripmime < Formula
  desc "Extract attachments out of MIME encoded email packages"
  homepage "https://pldaniels.com/ripmime/"
  url "https://pldaniels.com/ripmime/ripmime-1.4.0.10.tar.gz"
  sha256 "896115488a7b7cad3b80f2718695b0c7b7c89fc0d456b09125c37f5a5734406a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9a30b404042a4f673d072817d0040b8f11ddf31b222867b0663602cc23f3fa26" => :high_sierra
    sha256 "e36b04f4730b3bee47f3db26277fc3877932cef6bca7a62d81da3391d13e72e6" => :sierra
    sha256 "39ca3ac6ac2a7fffa3a3f6ff34cf6908a31b8b81a37e89cd19bf6f0a140c59dd" => :el_capitan
  end

  def install
    system "make", "LIBS=-liconv", "CFLAGS=#{ENV.cflags}"
    bin.install "ripmime"
    man1.install "ripmime.1"
  end
end
