class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/russellhancox/duti"
  url "https://github.com/russellhancox/duti/archive/master.tar.gz"
  version "1.7"
  sha256 "65d604eaf9d5c1e6931d26e934c1bac6972bb6ccebc1e34a14f4d68c5b8a8c2c"
  head "https://github.com/russellhancox/duti.git"

  def install
    bin.mkpath
    system "make"
    bin.install "duti"
    man1.install "duti.1"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end
  
end
