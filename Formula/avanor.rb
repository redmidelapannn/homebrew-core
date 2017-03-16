class Avanor < Formula
  desc "Quick-growing roguelike game with easy ADOM-like UI"
  homepage "https://avanor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avanor/avanor/0.5.8/avanor-0.5.8-src.tar.bz2"
  sha256 "8f55be83d985470b9a5220263fc87d0a0a6e2b60dbbc977c1c49347321379ef3"

  bottle do
    rebuild 1
    sha256 "6e230fae4d87154c8ead0e83fe7fb168f1e5b5fd91032caea5e7d8ba538da8ad" => :sierra
    sha256 "a1c154fe38bd40bbfd6429819ac4818b7f12cc00d459b4df779cfccbef652b79" => :el_capitan
    sha256 "5e02f67a3695808c00a85793a3bac65947bcd1d94b45d40f41b8f344a5fe4263" => :yosemite
  end

  # Upstream fix for clang: https://sourceforge.net/p/avanor/code/133/
  patch :p0 do
    url "https://gist.githubusercontent.com/mistydemeo/64f47233ee64d55cb7d5/raw/c1847d7e3a134e6109ad30ce1968919dd962e727/avanor-clang.diff"
    sha256 "2d24ce7b71eb7b20485d841aabffa55b25b9074f9a5dd83aee33b7695ba9d75c"
  end

  def install
    system "make", "DATA_DIR=#{pkgshare}/", "CC=#{ENV.cxx}", "LD=#{ENV.cxx}"
    bin.install "avanor"
    pkgshare.install "manual"
  end

  test do
    script = (testpath/"script.exp")
    script.write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout 10
      spawn avanor
      send -- "\e"
      expect eof
    EOS
    script.chmod 0700
    system "./script.exp"
  end
end
