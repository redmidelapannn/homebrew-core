class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://ftp.vector.co.jp/69/81/1362/FD-3.01d.tar.gz"
  sha256 "aa33c09d2e51c486fb428e3a17c31a1db0acc3b04083b84c4f9e6259c7ffb6da"

  bottle do
    sha256 "7c6dd78810c73e60766e15d41e47861a31978b55315afc1b4044ed1bc39588b0" => :high_sierra
    sha256 "f52e2352bdf61282f7b7d4f93e66c257d926cfa62929fd9899c0396857e10047" => :sierra
    sha256 "5a47bda98dfcdd47f0ff089172a2fc0e6f3c10fff20417b57c4c105971f226e8" => :el_capitan
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

  def caveats; <<~EOS
    To install the initial config file:
        install -c -m 0644 #{share}/fd2rc.dist ~/.fd2rc
    To set application messages to Japanese, edit your .fd2rc:
        MESSAGELANG="ja"
    EOS
  end

  test do
  end
end
