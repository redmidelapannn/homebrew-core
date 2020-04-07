class Delta < Formula
  desc "Programatically minimize files to isolate features of interest"
  homepage "http://delta.tigris.org/"
  url "https://deb.debian.org/debian/pool/main/d/delta/delta_2006.08.03.orig.tar.gz"
  sha256 "38184847a92b01b099bf927dbe66ef88fcfbe7d346a7304eeaad0977cb809ca0"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "b67231611bb8d67a9b5f27b64d737f8b7b9282a400a5b1f69984f42fe3c77ee0" => :catalina
    sha256 "973478bf573ed7ccf7ccb53094a69a3b22b01fb6513f14bf1f17fda6306f10aa" => :mojave
    sha256 "b4a8b2d79d6987eb766adb17847c7065e904557e7d2bb0af5cebc9a84dfb5291" => :high_sierra
  end

  conflicts_with "git-delta", :because => "both install a `delta` binary"

  def install
    system "make"
    bin.install "delta", "multidelta", "topformflat"
  end

  test do
    (testpath/"test1.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int i = -1;
        unsigned int j = i;
        printf("%d\n", j);
      }

    EOS
    (testpath/"test1.sh").write <<~EOS
      #!/usr/bin/env bash

      clang -Weverything "$(dirname "${BASH_SOURCE[0]}")"/test1.c 2>&1 | \
      grep 'implicit conversion changes signedness'

    EOS

    chmod 0755, testpath/"test1.sh"
    system "#{bin}/delta", "-test=test1.sh", "test1.c"
  end
end
