class Ib < Formula
  desc "C/C++ build tool that automatically resolves included source"
  homepage "https://github.com/JasonL9000/ib"
  url "https://github.com/JasonL9000/ib/archive/0.7.1.tar.gz"
  sha256 "a5295f76ed887291b6bf09b6ad6e3832a39e28d17c13566889d5fcae8708d2ec"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d0025aa7b9f10d7e84f53eca2a727e2494df126191e2f88fc95a4020f8afacd2" => :high_sierra
    sha256 "d0025aa7b9f10d7e84f53eca2a727e2494df126191e2f88fc95a4020f8afacd2" => :sierra
    sha256 "d0025aa7b9f10d7e84f53eca2a727e2494df126191e2f88fc95a4020f8afacd2" => :el_capitan
  end

  depends_on "python@2"

  def install
    prefix.install "common.cfg", "debug.cfg", "release.cfg", "asan.cfg", "__ib__"
    bin.install "ib"
  end

  test do
    mkdir testpath/"example" do
      (testpath/"example/debug.cfg").write <<~EOS
        cc = Obj(
          tool='clang',
          flags=[ '--std=c++14' ],
          hdrs_flags=[ '-MM', '-MG' ],
          incl_dirs=[]
        )

        link = Obj(
          tool='gcc',
          flags=[ '-pthread' ],
          libs=[ 'stdc++' ],
          static_libs=[],
          lib_dirs=[]
        )

        make = Obj(
          tool='make',
          flags=[],
          all_pseudo_target='all'
        )
      EOS

      (testpath/"example/hello.cc").write <<~EOS
        #include <iostream>

        int main(int, char*[]) {
          std::cout << "Hello World!" << std::endl;
          return 0;
        }
      EOS

      touch testpath/"example/__ib__"
      system "#{bin}/ib", "hello"
      system "../out/debug/hello"
    end
  end
end
