class Delta < Formula
  desc "Programatically minimize files to isolate features of interest"
  homepage "http://delta.tigris.org/"
  url "https://deb.debian.org/debian/pool/main/d/delta/delta_2006.08.03.orig.tar.gz"
  sha256 "38184847a92b01b099bf927dbe66ef88fcfbe7d346a7304eeaad0977cb809ca0"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "a82f1025787260ba2068d42d7f402905ec77e08271414e68ba123f71bafb3d93" => :mojave
    sha256 "3e74bd6507988793ac19a22556b8f94e9ea5ccd1d1d6c4c2ef9ec1c2d9a4b4e7" => :high_sierra
    sha256 "e70569dab2d7b6e40d4fe2a0d82c48797965561eb249e69e2cda387ce1df1e15" => :sierra
  end

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
