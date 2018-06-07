class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20180603.tar.gz"
  sha256 "66d8b48e001136d6d68b4c467c740753c56becceab9138632b479cb6c559074f"
  head "https://github.com/Winetricks/winetricks.git"

  bottle :unneeded

  option "with-zenity", "Zenity is needed for GUI"

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unrar"
  depends_on "wine" => :optional
  depends_on "zenity" => :optional

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  def caveats; <<~EOS
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
  EOS
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
