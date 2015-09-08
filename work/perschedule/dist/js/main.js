/****************************************************
  > File Name    : main.js
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年09月02日 星期三 11时51分40秒
 ****************************************************/

;(function () {
    $(document).ready(function () {
        var musicSongIds = {
            bd: [
                602998, 282001, 2187454, 120218312, 296240,
                946215, 266074, 273784, 122674119, 1371556,
                88328574, 354877, 489377, 2111993,
            ],
        };

        var bdMusic = {
            getSongIdUrl: function (parent) {
                var baseUrl = 'http://music.baidu.com/data/music/fmlink?songIds=';
                $.ajax({
                    url: baseUrl + parent.songId,
                    method: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        if (data.errorCode == '22000') {
                            playMusic.play({
                                name: data.data.songList[0].songName,
                                artist: data.data.songList[0].artistName,
                                album: data.data.songList[0].albumName,
                                url: data.data.songList[0].songLink
                            });

                            // parent.fullData = data;
                            parent.name = data.data.songList[0].songName;
                            return parent;
                        } else if (data.errorCode == '22232'){
                            $(".music-play-error").html('Sorry, it\'s Only provided for Chinese.');
                            $(".music-play-error").show();
                        }

                        console.log("See " + this.url + " errorCode !");
                        return null;
                    },
                    error: function (jqXHR, status, error) {
                        // show error
                        if (error) {
                            $(".music-play-error").html(error);
                        }
                        $(".music-play-error").show();

                        // try or not
                        if (! playMusic.noMoreTry()) {
                            // count try times 
                            playMusic.countTryTimes += 1;

                            // Try another after 10 seconds
                            setTimeout(function () {
                                playMusic.play();
                            }, 10000);
                        }
                    }
                });
            },
            play: function (parentObj) {
                return this.getSongIdUrl(parentObj);
            }
        };

        var playMusic = {
            maxTryTimes: 10,
            countTryTimes: 1,
            noMoreTry: function () {
                return this.countTryTimes >= this.maxTryTimes;
            },
            source: {
                "06:00": {
                    type: 'bdmusic',
                    songId: 14351939,
                    play: function () {
                        bdMusic.play(this);
                    },
                    name: "Could This Be Love"
                },
                "06:10": {
                    type: 'bdmusic',
                    songId: 602998,
                    play: function () {
                        bdMusic.play(this);
                    }
                },
                "12:30": {
                    type: 'bdmusic',
                    songId: 88853189,
                    play: function () {
                        bdMusic.play(this);
                    },
                    name: "终于等到你"
                },
                "13:00": {
                    type: 'bdmusic',
                    songId: 88853189,
                    play: function () {
                        bdMusic.play(this);
                    },
                    name: "终于等到你"
                },
                "22:30": {
                    type: 'bdmusic',
                    songId: 131058742,
                    play: function () {
                        bdMusic.play(this);
                    },
                    name: "青春的约定"
                },
                "23:00": {
                    type: 'bdmusic',
                    songId: 122123906,
                    play: function () {
                        bdMusic.play(this);
                    },
                    name: "晚安瞄"
                },
                random: [
                    "http://yinyueshiting.baidu.com/data2/music/132087971/13105874279200128.mp3?xcode=329c31944e2abc019d88bb873c3ec0e5",
                    "http://7xljtg.com1.z0.glb.clouddn.com/走在冷风中--刘思涵.mp3",
                    "http://7xljtg.com1.z0.glb.clouddn.com/好久不见--陈奕迅.mp3",
                    "http://7xljtg.com1.z0.glb.clouddn.com/突然好想你--五月天.mp3",
                    "http://7xljtg.com1.z0.glb.clouddn.com/A%20Little%20Love--冯曦妤.mp3",
                    "http://7xljtg.com1.z0.glb.clouddn.com/最初的梦想--范玮琪.mp3",
                    "http://7xljtg.com1.z0.glb.clouddn.com/nyru.mp3",
                    "http://7xljtg.com1.z0.glb.clouddn.com/心动--陈洁仪.mp3"
                ],
                randomBd: {
                    type: 'bdmusic',
                    songIds: musicSongIds.bd,
                    play: function () {
                        var id = Math.floor(Math.random() * this.songIds.length);
                        this.songId = this.songIds[id];
                        bdMusic.play(this);
                    }
                }
            },
            getSourceCode: function (options) {
                var spectionField = this.source[options.beginTime];
                if (! spectionField) {
                    // var id = Math.floor(Math.random() * this.source.random.length);
                    // var source_code = '<audio src="' 
                    //    + this.source.random[id]
                    //    + '" autoplay="autoplay"></autoplay>';
                    // options.selector.append(source_code);
                    return this.source
                                .randomBd
                                .play();
                }

                // type == bdmusic
                if (spectionField.type == 'bdmusic') {
                    return spectionField.play();
                }
                
                setTimeout(function () {
                    this.selector.html(""); 
                }, 180000);

                return options.selector.append('<audio src=\'' + 
                        spectionField.url + 
                        '\' song-name="' +
                        spectionField.name + 
                        '"autoplay="autoplay"></autoplay>');
            },
            selector: function () {
                return $("#bg_music");  
            },
            play: function (options) {
                if (! options) {
                    options = { beginTime: 'unknown'};
                }

                selector = this.selector();
                selector.html("");

                if (options.url) {
                    setTimeout(function () {
                        this.selector.html(""); 
                    }, 180000);

                    return selector.append('<audio ' + 
                            ' src=\''           + options.url       + '\' ' +
                            ' song-name="'      + options.name      + '" ' +
                            ' song-artist="'    + options.artist    + '" ' +
                            ' song-album="'     + options.album     + '" ' +
                            ' autoplay="autoplay"></autoplay>');
                }

                this.getSourceCode({
                    selector: selector,
                    beginTime: options.beginTime
                });
            },
            stop: function () {
                var selector = this.selector();
                if (selector.children().length) {
                    selector.html("");
                    return 0;
                }
                return -1;
            }
        };

        var flag = true; // show alert event
        var current = null; // store current tr
        var setEventOn = function () {
            var i = null,
                tr = null,
                beginTime = null,
                bh = null, bs = null,
                endTime = null,
                eh = null, es = null,
                scheduleColumns = $("tr");
            var date = new Date();
            for (i=0; i<scheduleColumns.length; ++i) {
                tr = scheduleColumns[i];
                tr.className = "";
                beginTime = tr.getAttribute("data-time-begin");
                endTime = tr.getAttribute("data-time-end");
                if (! beginTime) {
                    continue;
                }
                bs = parseInt(beginTime.split(":")[1]);
                bh = parseInt(beginTime.split(":")[0]) + bs/60;
                es = parseInt(endTime.split(":")[1]);
                eh = parseInt(endTime.split(":")[0]) + es/60;

                now = parseInt(date.getHours()) + parseInt(date.getMinutes())/60;

                if (now >= bh && now < eh) {
                    function showEvent () {
                        if (tr.children.length > 2) {
                            $("#event-show").html(tr.children[2].innerText);
                        }
                        else {
                            $("#event-show").html(tr.children[1].innerText);
                        }
                        $("#event-alert-btn").click();
                        // change button show message
                        var timeless = 9;
                        var intervalObj = setInterval(function () {
                            $("#event-close-btn").html("Close(" + timeless + ")");
                            timeless -= 1;
                        }, 1000);
                        // auto close after 10 seconds
                        setTimeout(function () {
                            $("#event-close-btn").trigger("click");
                            clearInterval(intervalObj);
                        }, 10000);
                    }

                    if (current != tr) {
                        showEvent();
                        playMusic.play({
                            beginTime: beginTime
                        });
                        current = tr;
                    }

                    tr.className = "time-on";
                    window.location.href = "#" + tr.id;
                    // if (flag) {
                    //    showEvent();
                    // }
                    // flag = false;
                    break;
                }
            }
        }
        setEventOn();
        setInterval(setEventOn, 10000);

        // keyPress
        $(document).on("keypress", function (key) {
            if (key.keyCode == 32) {
                if (! playMusic.stop())
                    console.log("Manually stop music.");
            }
        });
    });
})($);
