//
//  SLEditProfileViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 25/07/2023.
//

#import "SLEditProfileViewController.h"

@interface SLEditProfileViewController () <UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDoB;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgButtonMale;
@property (weak, nonatomic) IBOutlet UIImageView *imgButtonFemale;

@property (nonatomic) BOOL isMale;
@property (nonatomic) NSString *gender;
@end

@implementation SLEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    self.isMale = YES;
    
    // Get Data from UserDefaults
    self.imgProfile.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedImage"]] ;
    self.textFieldName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    self.textFieldEmail.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    self.textFieldDoB.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"dob"];
    self.gender = [[NSUserDefaults standardUserDefaults]objectForKey:@"gender"];
    
    if([self.gender  isEqual: @"Male"]) {
        self.isMale = YES;
    } else {
        self.isMale = NO;
    }
}

- (void)setupView {
    // Setup Image Profile
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2;
    self.imgProfile.clipsToBounds = YES;
    UITapGestureRecognizer *imgProfileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imgProfile addGestureRecognizer:imgProfileTap];
    self.imgProfile.userInteractionEnabled = YES;
    
    // Setup TextField DOB
    UITapGestureRecognizer *doBTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldTapped:)];
    [self.view addGestureRecognizer:doBTap];
    UIDatePicker *dobPicker = [[UIDatePicker alloc]init];
    dobPicker.datePickerMode = UIDatePickerModeDate;
    dobPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    [dobPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [dobPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventEditingDidEnd];
    self.textFieldDoB.inputView = dobPicker;
    
    // Setup gender option
    UITapGestureRecognizer *maleTapp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maleTapped:)];
    UITapGestureRecognizer *femaleTapp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(femaleTapped:)];
    
    [self.imgButtonMale addGestureRecognizer:maleTapp];
    [self.imgButtonFemale addGestureRecognizer:femaleTapp];
    self.imgButtonMale.userInteractionEnabled = YES;
    self.imgButtonFemale.userInteractionEnabled = YES;
}

- (void)maleTapped:(UITapGestureRecognizer *)gesture {
    if(self.isMale == YES) {
        self.imgButtonMale.image = [UIImage systemImageNamed:@"record.circle"];
        self.imgButtonFemale.image = [UIImage systemImageNamed:@"circle"];
    } else {
        self.imgButtonMale.image = [UIImage systemImageNamed:@"circle"];
        self.imgButtonFemale.image = [UIImage systemImageNamed:@"record.circle"];
    }
    self.isMale = YES;
}

- (void)femaleTapped:(UITapGestureRecognizer *)gesture {
    if(self.isMale == NO) {
        self.imgButtonMale.image = [UIImage systemImageNamed:@"circle"];
        self.imgButtonFemale.image = [UIImage systemImageNamed:@"record.circle"];
    } else {
        self.imgButtonMale.image = [UIImage systemImageNamed:@"record.circle"];
        self.imgButtonFemale.image = [UIImage systemImageNamed:@"circle"];
    }
    self.isMale = NO;
}

#pragma mark - TextField DOB
- (void)textFieldTapped:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

- (void)dateChanged:(UIDatePicker *) datePicker {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MM/dd/yyyy"];
    self.textFieldDoB.text = [dateFormater stringFromDate:datePicker.date];
//    [self.view endEditing:YES];
}

#pragma mark - Change Image Profile
- (void)imageTapped:(UITapGestureRecognizer *)gesture {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:libraryAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    self.imgProfile.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Transition button
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.imgProfile.image) forKey:@"SelectedImage"];
        [[NSUserDefaults standardUserDefaults] setObject:self.textFieldName.text forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] setObject:self.textFieldEmail.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:self.textFieldDoB.text forKey:@"dob"];
        
        if(self.isMale){
            self.gender = @"Male";
        } else {
            self.gender = @"Female";
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.gender forKey:@"gender"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([self.delegate respondsToSelector:@selector(editProfileViewControllerDidClose:)]) {
            [self.delegate editProfileViewControllerDidClose:self];
        }
    }];
    
}

@end
