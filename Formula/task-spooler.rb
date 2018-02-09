class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "http://vicerveza.homeunix.net/~viric/soft/ts/"
  url "http://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.tar.gz"
  sha256 "4f53e34fff0bb24caaa44cdf7598fd02f3e5fa7cacaea43fa0d081d03ffbb395"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "06622333d731a40bc33d87a6fec7f5dd1df32d646a8b45ea951e56a69faa3a30" => :high_sierra
    sha256 "c86699d1ba2cf4b14a2ed3a725b56bd8e21a3e4d321517befef33f170fbce90f" => :sierra
    sha256 "cc548df26a9286762eda74e39177dc76776cea86c2de8e79aa172f703d745717" => :el_capitan
  end

  if Tab.for_name("moreutils").with?("ts")
    conflicts_with "moreutils", :because => "both install a `ts` executable."
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ts", "-l"
  end
end
