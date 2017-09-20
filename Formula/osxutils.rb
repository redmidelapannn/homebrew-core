class Osxutils < Formula
  desc "Suite of Mac OS command-line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://github.com/specious/osxutils/archive/v1.9.0.tar.gz"
  sha256 "9c11d989358ed5895d9af7644b9295a17128b37f41619453026f67e99cb7ecab"
  head "https://github.com/specious/osxutils.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "617de97c66d5728e5f5de577a9580d046b71bd2938a9cbe005762aee22c77be7" => :sierra
    sha256 "75c830f9a34e194d51f04fdc58870fca889a668700b5a3aec0f020413e8783f4" => :el_capitan
  end

  conflicts_with "trash", :because => "both install a `trash` binary"
  conflicts_with "trash-cli", :because => "both install a `trash` binary"
  conflicts_with "leptonica",
    :because => "both leptonica and osxutils ship a `fileinfo` executable."
  conflicts_with "wiki", :because => "both install `wiki` binaries"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/trash"
  end
end
