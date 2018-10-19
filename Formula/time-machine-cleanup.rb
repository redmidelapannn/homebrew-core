class TimeMachineCleanup < Formula
  desc "Clean up Time Machine backups and reduce its size"
  homepage "https://github.com/emcrisostomo/Time-Machine-Cleanup"
  url "https://github.com/emcrisostomo/Time-Machine-Cleanup/releases/download/2.0.0/tm-cleanup-2.0.0.tar.gz"
  sha256 "e2beac0ef924e1b12df453205767147ef54eb0518507558222df8688b8e8adc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a7b2e95a50e3883b04c82128be82e0cf538b4908d2621c73d9a8c9cd0a1dd63" => :mojave
    sha256 "4e991f772468324b759767fd69b6cfa377aa64e2cc5279cc8513f31d20791957" => :high_sierra
    sha256 "833f3cb870861f4b756adc720cfe8f6887fff505c345472ed4ced02693b276b7" => :sierra
  end

  depends_on "dialog"

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tm-cleanup.sh", "-h"
  end
end
