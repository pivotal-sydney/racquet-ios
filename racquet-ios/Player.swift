import Foundation

@warn_unused_result
func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.twitter_handle == rhs.twitter_handle
}

struct Player: Hashable {

    var name: String
    var twitter_handle: String
    var image_url: String

    init(name: String, twitter_handle: String, image_url: String) {
        self.name = name
        self.twitter_handle = "@" + twitter_handle
        self.image_url = image_url
    }

    var hashValue: Int {
        return twitter_handle.hashValue
    }
}