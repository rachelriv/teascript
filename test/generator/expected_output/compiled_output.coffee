class CompiledOutput

  @program01 =
    '''(function () {
        (function () {
            var _v1 = 14;
            while ( ( _v1 < 20 ) ) {
                (function () {
                    _v1 = ( _v1 + 1 );
                }());
            }
            var _v2 = ( ( 5 * 6 ) - _v1 );
            var _v3 = 5.5;
            var _v4 = ( ! true );
        }());
    }());'''

  @program02 =
    '''(function () {
        (function () {
            var _v1 = [
                1,
                2.5,
                3,
                4.8
            ];
            var _v2 = [
                "hello",
                16,
                "goodbye",
                4.5
            ];
        }());
    }());'''

  @program03 =
    '''(function () {
        (function () {
            var _v1 = {
                'first': 1,
                'second': 2,
                'third': 3
            };
            var _v2 = {
                'a': "ayy",
                'b': "bee",
                'c': "sea"
            };
        }());
    }());'''

  @program04 =
    '''(function () {
        (function () {
            var _v1 = {
                1: true,
                2: true,
                3: true,
                4: true,
                5: true
            };
            var _v2 = {
                'dog': true,
                'cat': true,
                'mouse': true
            };
        }());
    }());'''

  @program05 =
    '''(function () {
        (function () {
            var _v1 = [
                1,
                2,
                3,
                4
            ];
            var _v2 = [
                12.3,
                10.0,
                1234.1234
            ];
        }());
    }());'''

  @program06 =
    '''(function () {
        (function () {
            var _v1 = "hellooo";
            console.log( _v1 );
        }());
    }());'''

  @program07 =
    '''(function () {
        (function () {
            var _v1 = function () {
                return console.log( 'testing' );
            };
            _v1();
        }());
    }());'''

  @program08 =
    '''(function () {
        (function () {
            var _v1 = function () {
                return (function () {
                    console.log( "hello" );
                    console.log( "goodbye" );
                }());
            };
            _v1();
        }());
    }());'''

  @program10 =
    '''(function () {
        (function () {
            var _v1 = function (_v2) {
                return (function () {
                    ( _v2 * 2 )
                }());
            };
            _v1 (_v1 (_v1 ( 2 ) ) );
            _v1 (_v1 (_v1 (_v1 (_v1 ( 3 ) ) ) ) );
        }());
    }());'''

  @program11 =
    '''(function () {
        (function () {
            var _v1 = function (_v2) {
                return (function () {
                    ( _v2 * 2 )
                }());
            };
        }());
    }());'''

  @program12 =
    '''(function () {
        (function () {
            var _v1 = function (_v2, _v3) {
                return (function () {
                    ( _v2 * _v3 )
                }());
            };
        }());
    }());'''

  @program13 =
    '''(function () {
        (function () {
            Math.sqrt( 100 );
            Math.sqrt( 9 );
            Math.sqrt( 1 );
            Math.sqrt( 0 );
        }());
    }());'''

module.exports = CompiledOutput
