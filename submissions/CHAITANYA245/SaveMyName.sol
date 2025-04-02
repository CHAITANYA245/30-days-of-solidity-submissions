// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SaveMyName {
    struct Profile {
        string name;
        string bio;
    }
    Profile public profile;

    function setProfile(string memory _name, string memory _bio) public  {
        profile = Profile(_name, _bio);
    }

    function getProfile() public view returns (string memory, string memory){
        return (profile.name, profile.bio);
    }
}