//
//  Stubs.swift
//  Ello
//
//  Created by Ryan Boyajian on 3/6/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import Ello


func stub<T: Stubbable>(values: [String : AnyObject]) -> T {
    return T.stub(values)
}

func urlFromValue(_ value: AnyObject? = nil) -> NSURL? {
    if value == nil { return nil }
    else if let url = value as? NSURL {
        return url
    } else if let str = value as? String {
        return NSURL(string: str)
    }
    return nil
}

let stubbedTextRegion: TextRegion = stub([:])

protocol Stubbable: NSObjectProtocol {
    static func stub(values: [String : AnyObject]) -> Self
}

extension User: Stubbable {
    class func stub(values: [String : AnyObject]) -> User {

        let relationship = (values["relationshipPriority"] as? String).map {
            Relationship(stringValue: $0)
        } ?? Relationship.None

        var user =  User(
            id: (values["id"] as? String) ?? "1",
            href: (values["href"] as? String) ?? "href",
            username: (values["username"] as? String) ?? "username",
            name: (values["name"] as? String) ?? "name",
            experimentalFeatures: (values["experimentalFeatures"] as? Bool) ?? false,
            relationshipPriority: relationship
            )
        user.avatar = values["avatar"] as? ImageAttachment
        user.identifiableBy = values["identifiableBy"] as? String
        user.postsCount = values["postsCount"] as? Int
        user.followersCount = values["followersCount"] as? String
        user.followingCount = values["followingCount"] as? Int
        user.formattedShortBio = values["formattedShortBio"] as? String
        user.externalLinks = values["externalLinks"] as? String
        user.coverImage = values["coverImage"] as? ImageAttachment
        user.backgroundPosition = values["backgroundPosition"] as? String
        user.posts = values["posts"] as? [Post]
        user.mostRecentPost = values["mostRecentPost"] as? Post
        user.profile = values["profile"] as? Profile
        return user
    }
}

extension Profile: Stubbable {
    class func stub(values: [String : AnyObject]) -> Profile {
        var profile = Profile(
            createdAt: (values["createdAt"] as? NSDate) ?? NSDate(),
            shortBio: (values["shortBio"] as? String) ?? "shortBio",
            externalLinksList: (values["externalLinksList"] as? [String]) ?? ["externalLinksList"],
            email: (values["email"] as? String) ?? "email@example.com",
            confirmedAt: (values["confirmedAt"] as? NSDate) ?? NSDate(),
            isPublic: (values["isPublic"] as? Bool) ?? true,
            hasCommentingEnabled: (values["hasCommentingEnabled"] as? Bool) ?? true,
            hasSharingEnabled: (values["hasSharingEnabled"] as? Bool) ?? true,
            hasRepostingEnabled: (values["hasRepostingEnabled"] as? Bool) ?? true,
            hasAdNotificationsEnabled: (values["hasAdNotificationsEnabled"] as? Bool) ?? true,
            allowsAnalytics: (values["allowsAnalytics"] as? Bool) ?? true,
            postsAdultContent: (values["postsAdultContent"] as? Bool) ?? false,
            viewsAdultContent: (values["viewsAdultContent"] as? Bool) ?? false,
            notifyOfCommentsViaEmail: (values["notifyOfCommentsViaEmail"] as? Bool) ?? true,
            notifyOfInvitationAcceptancesViaEmail: (values["notifyOfInvitationAcceptancesViaEmail"] as? Bool) ?? true,
            notifyOfMentionsViaEmail: (values["notifyOfMentionsViaEmail"] as? Bool) ?? true,
            notifyOfNewFollowersViaEmail: (values["notifyOfNewFollowersViaEmail"] as? Bool) ?? true,
            subscribeToUsersEmailList: (values["subscribeToUsersEmailList"] as? Bool) ?? true
            )
        return profile
    }
}

extension Post: Stubbable {
    class func stub(values: [String : AnyObject]) -> Post {

        var post = Post(
            id: (values["id"] as? String) ?? "666",
            createdAt: (values["createdAt"] as? NSDate) ?? NSDate(),
            href: (values["href"] as? String) ?? "sample-href",
            token: (values["token"] as? String) ?? "sample-token",
            contentWarning: (values["contentWarning"] as? String) ?? "null",
            allowComments: (values["allowComments"] as? Bool) ?? false,
            summary: (values["summary"] as? [Regionable]) ?? [stubbedTextRegion]
            )

        // optional
        post.content = (values["content"] as? [Regionable]) ?? [stubbedTextRegion]
        post.repostContent = (values["repostContent"] as? [Regionable]) ?? [stubbedTextRegion]
        post.repostId = (values["repostId"] as? String)
        post.repostPath = urlFromValue(values["repostPath"])
        post.repostViaId = (values["repostViaId"] as? String)
        post.repostViaPath = urlFromValue(values["repostViaPath"])
        post.viewsCount = values["viewsCount"] as? Int
        post.commentsCount = values["commentsCount"] as? Int
        post.repostsCount = values["repostsCount"] as? Int
        // links / nested resources
        post.author = (values["author"] as? User)
        post.assets = (values["assets"] as? [String : Asset])
        post.comments = (values["comments"] as? [Comment])

        return post
    }

    class func stubWithRegions(values: [String : AnyObject], summary: [Regionable] = [], content: [Regionable] = []) -> Post {
        var mutatedValues = values
        mutatedValues.updateValue(summary, forKey: "summary")
        var post: Post = stub(mutatedValues)
        post.content = content
        return post
    }

}

extension Comment: Stubbable {
    class func stub(values: [String : AnyObject]) -> Comment {

        var comment = Comment(
            id: (values["id"] as? String) ?? "888",
            createdAt: (values["createdAt"] as? NSDate) ?? NSDate(),
            postId: (values["postId"] as? String) ?? "666",
            content: (values["content"] as? [Regionable]) ?? [stubbedTextRegion]
            )

        // links
        comment.assets = (values["assets"] as? [String : Asset])
        comment.author = (values["author"] as? User)
        comment.parentPost = (values["parentPost"] as? Post)

        return comment
    }
}

extension TextRegion: Stubbable {
    class func stub(values: [String : AnyObject]) -> TextRegion {
        return TextRegion(
            content: (values["content"] as? String) ?? "Lorem Ipsum"
        )
    }
}

extension ImageRegion: Stubbable {
    class func stub(values: [String : AnyObject]) -> ImageRegion {
        return ImageRegion(
            asset: values["asset"] as? Asset,
            alt: values["alt"] as? String,
            url: values["url"] as? NSURL
        )
    }
}

extension UnknownRegion: Stubbable {
    class func stub(values: [String : AnyObject]) -> UnknownRegion {
        return UnknownRegion(name: "no-op")
    }
}

extension Activity: Stubbable {
    class func stub(values: [String : AnyObject]) -> Activity {

        let activityKindString = (values["kind"] as? String) ?? Activity.Kind.FriendPost.rawValue
        let subjectTypeString = (values["subjectType"] as? String) ?? SubjectType.Post.rawValue

        let activity = Activity(
            id: (values["id"] as? String) ?? "1234",
            createdAt: (values["createdAt"] as? NSDate) ?? NSDate(),
            kind: Activity.Kind(rawValue: activityKindString) ?? Activity.Kind.FriendPost,
            subjectType: SubjectType(rawValue: subjectTypeString) ?? SubjectType.Post
            )

        let defaultSubject = activity.subjectType == SubjectType.User ? User.stub([:]) : Post.stub([:])
        activity.subject = (values["subject"] as? JSONAble) ?? defaultSubject

        return activity
    }
}

extension Asset: Stubbable {
    class func stub(values: [String : AnyObject]) -> Asset {
        return Asset(
            assetId:  (values["assetId"] as? String) ?? "1234",
            optimized: values["optimized"] as? ImageAttachment,
            smallScreen: values["smallScreen"] as? ImageAttachment,
            ldpi: values["ldpi"] as? ImageAttachment,
            mdpi: values["mdpi"] as? ImageAttachment,
            hdpi: values["hdpi"] as? ImageAttachment,
            xhdpi: values["xhdpi"] as? ImageAttachment,
            xxhdpi: values["xxhdpi"] as? ImageAttachment,
            xxxhdpi: values["xxxhdpi"] as? ImageAttachment
        )
    }
}

extension ImageAttachment: Stubbable {
    class func stub(values: [String : AnyObject]) -> ImageAttachment {
        return ImageAttachment(
            url: values["url"] as? NSURL,
            height: values["height"] as? Int,
            width: values["width"] as? Int,
            imageType: values["imageType"] as? String,
            size: values["size"] as? Int
        )
    }
}

extension Notification: Stubbable {
    class func stub(values: [String : AnyObject]) -> Notification {

        let author = (values["author"] as? User)
        let subjectTypeString = (values["subjectType"] as? String) ?? SubjectType.Unknown.rawValue
        let activityKindString = (values["kind"] as? String) ?? Activity.Kind.Unknown.rawValue

        return Notification(
            author: author,
            createdAt: (values["createdAt"] as? NSDate) ?? NSDate(),
            kind: Activity.Kind(rawValue: activityKindString) ?? Activity.Kind.Unknown,
            notificationId: (values["notificationId"] as? String) ?? "444",
            subjectType: SubjectType(rawValue: subjectTypeString) ?? SubjectType.Unknown
        )
    }
}
