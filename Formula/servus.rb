class Servus < Formula
  desc "Library and Utilities for zeroconf networking"
  homepage "https://github.com/HBPVIS/Servus"
  url "https://github.com/HBPVIS/Servus.git",
      :tag      => "1.5.1",
      :revision => "eee576548a05292179f4892d48b97108d8ed07c0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "956e07e4f4bc695ec262b83c783d7ed4d32df8d051ffdb40c5bffd3860cbc70e" => :mojave
    sha256 "64b03dd975b12b6608d85aa2358446b3103fdc9f75a7824f338d062479214863" => :high_sierra
    sha256 "64a289d09cde79d545f4f1ba816ce338e53b8a720706fa5d56eaf61a741b29f5" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Embed "serializeable" test from the servus 1.5.0 source
    (testpath/"test.cpp").write <<~EOS
      #define BOOST_TEST_MODULE servus_serializable
      #include <boost/test/unit_test.hpp>

      #include <servus/uint128_t.h>
      #include <servus/serializable.h>

      void dummyFunction(){}

      class SerializableObject : public servus::Serializable
      {
      public:
          std::string getTypeName() const final { return "test::serializable"; }

          servus::uint128_t getTypeIdentifier() const final
          {
              return servus::make_uint128( getTypeName( ));
          }

      private:
          bool _fromBinary( const void*, const size_t ) { return true; }
          bool _fromJSON( const std::string& ) { return true; }
      };


      BOOST_AUTO_TEST_CASE(serializable_types)
      {
          SerializableObject obj;
          BOOST_CHECK_EQUAL( obj.getTypeName(), "test::serializable" );
          BOOST_CHECK_EQUAL( servus::make_uint128( obj.getTypeName( )),
                             obj.getTypeIdentifier( ));
          BOOST_CHECK_EQUAL( obj.getSchema(), std::string( ));
      }

      BOOST_AUTO_TEST_CASE(serializable_registerSerialize)
      {
          SerializableObject obj;
          servus::Serializable::SerializeCallback callback( dummyFunction );

          obj.registerSerializeCallback( callback );
          BOOST_CHECK_THROW( obj.registerSerializeCallback( callback ),
                             std::runtime_error ); // callback already registered

          BOOST_CHECK_NO_THROW( obj.registerSerializeCallback(
              servus::Serializable::SerializeCallback( )));
          BOOST_CHECK_NO_THROW( obj.registerSerializeCallback( callback ));

          BOOST_CHECK_THROW( obj.registerSerializeCallback( callback ),
                             std::runtime_error ); // callback already registered
      }

      BOOST_AUTO_TEST_CASE(serializable_registerDeserialized)
      {
          SerializableObject obj;
          servus::Serializable::DeserializedCallback callback( dummyFunction );

          obj.registerDeserializedCallback( callback );
          BOOST_CHECK_THROW( obj.registerDeserializedCallback( callback ),
                             std::runtime_error ); // callback already registered

          BOOST_CHECK_NO_THROW( obj.registerDeserializedCallback(
              servus::Serializable::DeserializedCallback( )));
          BOOST_CHECK_NO_THROW( obj.registerDeserializedCallback( callback ));

          BOOST_CHECK_THROW( obj.registerDeserializedCallback( callback ),
                             std::runtime_error ); // callback already registered
      }

      BOOST_AUTO_TEST_CASE(serializable_binary)
      {
          SerializableObject obj;

          // fromBinary implemented
          BOOST_CHECK_NO_THROW( obj.fromBinary( new float[3], 3 ));

          // default toBinary (unimplemented)
          BOOST_CHECK_THROW( obj.toBinary(), std::runtime_error );
      }

      BOOST_AUTO_TEST_CASE(serializable_json)
      {
          SerializableObject obj;

          // fromJson implemented
          BOOST_CHECK_NO_THROW( obj.fromJSON( std::string( "testing..." )));

          // default toJson (unimplemented)
          BOOST_CHECK_THROW( obj.toJSON(), std::runtime_error );
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lServus", "-DBOOST_TEST_DYN_LINK",
                    "-L#{Formula["boost"].opt_lib}",
                    "-lboost_unit_test_framework-mt",
                    "-std=gnu++11", "test.cpp", "-o", "test"
    system "./test"
  end
end
