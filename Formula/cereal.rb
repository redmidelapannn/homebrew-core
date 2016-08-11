class Cereal < Formula
  desc "C++11 library for serialization"
  homepage "https://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.2.1.tar.gz"
  sha256 "7d321c22ea1280b47ddb06f3e9702fcdbb2910ff2f3df0a2554804210714434e"
  head "https://github.com/USCiLab/cereal.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f845cc133b95ef4ba7cf90412a26033aa643dba905bbdf859c453d0438b5773" => :el_capitan
    sha256 "08c130ea94d5b20e3314f93deda318f1b2d6177d2be9a490167adb2b021dec81" => :yosemite
    sha256 "f0504c9cc90d6358fdc10d1f075463905d7e581d80e5a45e374976e7bc797b63" => :mavericks
    sha256 "00ef7732975fb675326d0dc1f1a8732b995626075cb5f0a3f2740f28c3fcdda6" => :mountain_lion
  end

  # error: chosen constructor is explicit in copy-initialization
  patch :DATA if MacOS.version <= :mavericks

  option "with-test", "Build and run the test suite"

  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build if build.with? "tests"

  needs :cxx11

  def install
    ENV.cxx11
    if build.with? "test"
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make", "test"
    end
    include.install "include/cereal"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cereal/types/unordered_map.hpp>
      #include <cereal/types/memory.hpp>
      #include <cereal/archives/binary.hpp>
      #include <fstream>

      struct MyRecord
      {
        uint8_t x, y;
        float z;

        template <class Archive>
        void serialize( Archive & ar )
        {
          ar( x, y, z );
        }
      };

      struct SomeData
      {
        int32_t id;
        std::shared_ptr<std::unordered_map<uint32_t, MyRecord>> data;

        template <class Archive>
        void save( Archive & ar ) const
        {
          ar( data );
        }

        template <class Archive>
        void load( Archive & ar )
        {
          static int32_t idGen = 0;
          id = idGen++;
          ar( data );
        }
      };

      int main()
      {
        std::ofstream os("out.cereal", std::ios::binary);
        cereal::BinaryOutputArchive archive( os );

        SomeData myData;
        archive( myData );

        return 0;
      }
    EOS
    system ENV.cc, "-std=c++11", "-stdlib=libc++", "-lc++", "-o", "test", "test.cpp"
    system "./test"
  end
end

__END__
diff --git a/include/cereal/details/polymorphic_impl.hpp b/include/cereal/details/polymorphic_impl.hpp
index d72cd05..fee659f 100644
--- a/include/cereal/details/polymorphic_impl.hpp
+++ b/include/cereal/details/polymorphic_impl.hpp
@@ -223,7 +223,7 @@ namespace cereal
         auto lb = baseMap.lower_bound(baseKey);
 
         {
-          auto & derivedMap = baseMap.insert( lb, {baseKey, {}} )->second;
+          auto & derivedMap = baseMap.insert( lb, {baseKey, [](){}} )->second;
           auto derivedKey = std::type_index(typeid(Derived));
           auto lbd = derivedMap.lower_bound(derivedKey);
           auto & derivedVec = derivedMap.insert( lbd, { std::move(derivedKey), {}} )->second;
