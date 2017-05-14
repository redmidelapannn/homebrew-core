class Fdclone < Formula
  desc "Console-based file manager"
  homepage "http://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://hp.vector.co.jp/authors/VA012337/soft/fd/FD-3.01b.tar.gz"
  sha256 "d66d902cac9d4f64a91d42ceb487a138d544c9fd9cb2961730889cc8830303d4"

  bottle do
    rebuild 1
    sha256 "75964278eb14e35d9294b6266172eede245c1618b885b6ce2e68d09b21e071a6" => :sierra
    sha256 "4001c05561daad69e8c31e476ca52efccbfd997697dae01d3aedf3f7c456eafa" => :el_capitan
    sha256 "8b833207764c6dc076ca441808118ddc84abc54354145757a21533650dd96817" => :yosemite
  end

  depends_on "nkf" => :build

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/86107cf/fdclone/3.01b.patch"
    sha256 "c4159db3052d7e4abec57ca719ff37f5acff626654ab4c1b513d7879dcd1eb78"
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "MANTOP=#{man}", "install"

    %w[README FAQ HISTORY LICENSES TECHKNOW ToAdmin].each do |file|
      system "nkf", "-w", "--overwrite", file
      prefix.install "#{file}.eng" => file
      prefix.install file => "#{file}.ja"
    end

    share.install "_fdrc" => "fd2rc.dist"
  end

  def caveats; <<-EOS.undent
    To install the initial config file:
        install -c -m 0644 #{share}/fd2rc.dist ~/.fd2rc
    To set application messages to Japanese, edit your .fd2rc:
        MESSAGELANG="ja"
    EOS
  end
end
