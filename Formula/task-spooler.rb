class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://vicerveza.homeunix.net/~viric/soft/ts/"
  url "https://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.tar.gz"
  sha256 "4f53e34fff0bb24caaa44cdf7598fd02f3e5fa7cacaea43fa0d081d03ffbb395"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "947c377a8fe582882d81a89f96d28d7ebc85cd63ddce5d5129dfd697956c7059" => :high_sierra
    sha256 "2b192a4de35dc9de986579fc804accde617ea3acc07487fb5a6cf1ce0a59c5b7" => :sierra
    sha256 "e22d5b751c46f444916807e4de09dc940498261238b967676c8add314145a865" => :el_capitan
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
